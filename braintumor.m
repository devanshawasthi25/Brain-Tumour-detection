% Read the MRI image
img = imread('brain-mri.jpg');

% Convert the image to grayscale
gray_img = im2gray(img);

% Apply a median filter to remove noise
filtered_img = medfilt2(gray_img);

% Thresholding to create a binary image
threshold = graythresh(filtered_img);
binary_img = imbinarize(filtered_img, threshold);

% Morphological operations to clean up the binary image
se = strel('disk', 5);
clean_img = imopen(binary_img, se);
clean_img = imclose(clean_img, se);
clean_img = imfill(clean_img, 'holes');

% Label connected components
labeled_img = bwlabel(clean_img);

% Measure properties of image regions
stats = regionprops(labeled_img, 'Area', 'BoundingBox');

% Filter out small objects
area_threshold = 700; % You may need to adjust this value
large_objects = find([stats.Area] > area_threshold);

% Display the original and processed images
figure;
subplot(1, 2, 1); imshow(img); title('Original MRI Image');
subplot(1, 2, 2); imshow(gray_img); hold on; title('Detected Tumor');

% Highlight the detected tumor regions
for i = 1:length(large_objects)
    rectangle('Position', stats(large_objects(i)).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

hold off;
