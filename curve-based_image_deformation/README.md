# Curve-based Image Deformation

This graphical user interface tool is an implementation for *curve-based image deformation using moving least squares*. 

To use this tool, a user can select whether to execute deformation on a grid or an image, where the resolution or the corse grid size can be adjusted to reduce the number of pixels of the chosen grid or image. 
- For each control curve (handle), and before pressing on *Control Curves*, one can change the number of Legendre points in the parameterization.
- To place the curve handles, for every handle, place the key points of each handle first by left-clicking and then finish by right-clicking.
- After placing all the handles, the user may select the deformation class (*affine, similarity or rigid*) and the deformation method (*Point-based* or *Curve-based*), then press *Interactive Button*.
- To deform, one can place the cursor on the key points of the handles and move them while left-clicking. 
- In the deformation mode, one can switch between deformation classes, as well as modify the scale parameter (*alpha*). 
- To save the outcome, click *Save*, and to start a new application, left-click twice then press *Reset* button.

---
### Reference

S. Hua, S. Li and X. Li, "Image Deformation Based on Cubic Splines and Moving Least Squares," 2009 International Conference on Computational Intelligence and Software Engineering, 2009, pp. 1-4, doi: 10.1109/CISE.2009.5366816.
